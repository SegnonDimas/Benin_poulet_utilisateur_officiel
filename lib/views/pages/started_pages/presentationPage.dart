import 'dart:ui';

import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../../../tests/blurryContainer.dart';
import '../../models_ui/model_presentationPage.dart';

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

  void showUserProfilChoice() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: AppText(
            text: 'Que comptez-vous faire sur l\'application ?',
            fontSize: context.mediumText,
            maxLine: 2,
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: context.height * 0.17,
            child: Column(
              children: [
                ///VENDRE
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.INSCRIPTIONVENDEURPAGE);
                    },
                    child: Container(
                      height: appHeightSize(context) * 0.06,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.monetization_on_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: appWidthSize(context) * 0.05,
                          ),
                          AppText(
                            text: 'Vendre',
                            fontSize: context.mediumText,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: appWidthSize(context) * 0.05,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: context.largeText,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                ///ACHETER
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.INSCRIPTIONPAGE);
                    },
                    child: Container(
                      height: appHeightSize(context) * 0.06,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: appWidthSize(context) * 0.05,
                          ),
                          AppText(
                            text: 'Acheter',
                            fontSize: context.mediumText,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: appWidthSize(context) * 0.05,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: context.largeText,
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
              radius: context.height * 0.05,
              backgroundColor: Theme.of(context).colorScheme.background,
              child: Icon(
                Icons.question_mark,
                size: context.largeText * 2,
                color: AppColors.primaryColor,
              )),
          iconColor: Colors.white,
          elevation: 25,
          shadowColor: Theme.of(context).colorScheme.inversePrimary,
          actions: <Widget>[
            TextButton(
              child: AppText(
                text: 'Annuler',
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// initState
  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,

          /// corps de la page
          body: Stack(
            alignment: Alignment.center,
            children: [
              //GradientBall du haut
              Positioned(
                top: 20,
                left: 5,
                child: Hero(
                  tag: '1',
                  child: GradientBall(
                      size: Size.square(context.height * 0.25),
                      colors: const [
                        //blueColor,
                        Colors.deepPurple,
                        Colors.purpleAccent
                      ]),
                ),
              ),
              //GradientBall du bas
              Positioned(
                bottom: 0, //context.height * 0.8,
                right: 10,
                child: Hero(
                  tag: '2',
                  child: GradientBall(
                      size: Size.square(context.height * 0.17),
                      colors: const [Colors.orange, Colors.yellow]),
                ),
              ),

              // floutage de l'arrière-plan
              BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  //blur(sigmaX: 100, sigmaY: 100),
                  child: SizedBox()),

              // les éléments de la page
              PageView(
                controller: _pageViewController,
                // bloquer le scroll depuis cette pageView
                physics: const NeverScrollableScrollPhysics(),

                // liste des pages de la pageView
                children: List.generate(views.length, (index) {
                  // structure de chaque page de la pageView
                  // le SingleChildScrollView prévient les débordements de page sur certains appareils
                  return SingleChildScrollView(
                    child: Column(children: [
                      /// logo + titre
                      Padding(
                        padding: EdgeInsets.only(
                            top: context.height * 0.045,
                            right: context.width * 0.1,
                            left: context.width * 0.04,
                            bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // logo de Bénin poulet
                            Hero(
                              tag: 'logoTag',
                              child: CircleAvatar(
                                radius: context.height * 0.03,
                                child: Image.asset(
                                  'assets/logos/logoBlanc.png',
                                  fit: BoxFit.fill,
                                  height: context.height * 0.03,
                                ),
                              ),
                            ),

                            // le titre : Bénin Poulet (de la pageView)
                            Text(
                              views[selectedPage].title,
                              style: TextStyle(
                                  fontSize: context.largeText * 1.3,
                                  color: AppColors.primaryColor,
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
                            top: context.height * 0.04,
                            bottom: context.height * 0.02,
                            right: context.width * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 1,
                            ),
                            selectedPage == views.length - 1
                                ? SizedBox(
                                    height: context.height * 0.04,
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      showUserProfilChoice();
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: context.height * 0.04,
                                        width: context.height * 0.1,
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
                          height: MediaQuery.of(context).size.height * 0.57,
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
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.linear,
                                );
                              },
                              itemCount: views.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  // image + description
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // image caractéristique de chaque page
                                      Image.asset(
                                        views[selectedPage].image,
                                        height: context.height * 0.28,
                                      ),
                                      //espace
                                      SizedBox(
                                        height: context.height * 0.05,
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
                                                  fontSize: context.largeText,
                                                  fontWeight: FontWeight.w900,
                                                  color:
                                                      AppColors.primaryColor),
                                            ),
                                            //espace
                                            SizedBox(
                                              height: context.height * 0.01,
                                            ),
                                            //description
                                            Text(
                                              views[selectedPage].description,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: context.mediumText,
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
                        currentItem: selectedPage,
                        count: views.length,
                        unselectedColor:
                            Theme.of(context).colorScheme.background,
                        selectedColor: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(300),
                        duration: const Duration(milliseconds: 200),
                        size: Size(context.width * 0.1, context.height * 0.012),
                        unselectedSize:
                            Size(context.width * 0.03, context.height * 0.012),
                        boxShape: BoxShape.rectangle,
                      ),

                      //espace
                      SizedBox(
                        height: context.height * 0.06,
                      ),

                      /// le bouton d'INSCRIPTION ou SUIVANT (ne l'afficher que l'orsqu'on est sur la dernière page de la pageView)
                      // selectedPage == views.length - 1 ?

                      /// bouton SUIVANT / S'INSCRIRE
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: selectedPage == views.length - 1

                              /// bouton S'INSCRIRE
                              ? () {
                                  // dialog de choix du profil vendeur/client
                                  showUserProfilChoice();
                                }

                              /// bouton SUIVANT
                              : () {
                                  setState(() {
                                    selectedPage = selectedPage + 1;
                                  });

                                  ////_pageController.jumpToPage(selectedPage);

                                  _pageController.animateToPage(
                                    selectedPage,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.linear,
                                  );
                                },
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: context.width * 0.05,
                                right: context.width * 0.05),
                            child: Container(
                                height: context.height * 0.06,
                                width: context.width * 0.9,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(15),
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
                                  text: selectedPage == views.length - 1

                                      /// bouton S'INSCRIRE/SUIVANT
                                      ? 'S\'inscrire'
                                      : "Suivant",
                                  color: Colors.white,
                                  fontSize: context.largeText,
                                )),
                          ),
                        ),
                      )
                    ]),
                  );
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
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.linear,
                                );
                              },
                              child: const Icon(Icons.arrow_back_ios))
                          : SizedBox(),

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
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.linear,
                                );
                              },
                              child: const Icon(Icons.arrow_forward_ios))
                          : SizedBox()
                    ],
                  ),
                ),
              )),
            ],
          )),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageViewController.dispose();
    super.dispose();
  }
}
