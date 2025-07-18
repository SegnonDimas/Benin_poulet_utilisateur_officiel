import 'package:benin_poulet/utils/app_utils.dart';
import 'package:benin_poulet/views/pages/connexion_pages/loginPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../../../bloc/auth/auth_bloc.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/app_textField.dart';
import '../../colors/app_colors.dart';
import '../../models_ui/model_carouselItem.dart';
import '../../models_ui/model_recommandation.dart';

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

  final List<ModelRecomandation> _listRecommandations = const [
    ModelRecomandation(
      shopName: 'Le Poulailler',
      backgroundImage: 'assets/images/pouletCouveuse.png',
    ),
    ModelRecomandation(
      shopName: 'Mike Store',
    ),
    ModelRecomandation(
      shopName: 'Le gros',
      backgroundImage: 'assets/images/pouletCouveuse.png',
    ),
    ModelRecomandation(
      shopName: 'AcolPro',
      price: 5000,
      unit: 'poulet',
    ),
    ModelRecomandation(
      shopName: 'Linge d\'or',
      price: 2500,
      unit: 'plateau',
    ),
    ModelRecomandation(
      shopName: 'Smart Solutions Innova',
      price: 50,
    ),
    ModelRecomandation(shopName: ''),
    ModelRecomandation(),
    ModelRecomandation(),
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
    const Icon(
      //Icons.wechat_rounded,
      Icons.shopping_cart,
      //size: largeText() * 1.2,
    ),
  ];

  /* userData(String data) async {
    final user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc('${user?.uid}')
        .get();
    Map<String, dynamic>? userData = doc.data() ?? {};
    data = 'authIdentifier';
    print(":::::::::${userData["$data"]}");
    return userData['$data'];
  }*/

  bool _shouldInterceptBack = true;

  User? _user;
  Map<String, dynamic>? _userData;
  Future<void> _loadUserData() async {
    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      String userId = _user!.uid;

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      // Récupérez les données spécifiques de l'utilisateur
      _userData = userSnapshot.data() ?? {};

      // Mettez à jour l'état pour déclencher un réaffichage
      if (mounted) {
        setState(() {});
      }
    }
  }

  // initState
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabcontroller = TabController(length: 2, vsync: this, initialIndex: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _shouldInterceptBack = true;
      });
    });
    _loadUserData();
    //nomUtilisateur = (userData('authIdentifier'));
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state /*as AuthAuthenticated*/;
    final user = FirebaseAuth.instance.currentUser;

    //var nomUtilisateur = userData('authIdentifier');
    //var nomUtilisateur = 'User';

    return _shouldInterceptBack
        ? WillPopScope(
            onWillPop: () async {
              final shouldPop = await AppUtils.showExitConfirmationDialog(
                  context,
                  message: 'Voulez-vous vraiment quitter l\'application ?');
              return shouldPop; // true = autorise le pop, false = bloque
            },
            child: SafeArea(
              top: false,
              child: Scaffold(
                appBar: AppBar(
                  title: AppText(
                      text: _userData!['fullName'] ??
                          _userData!['authIdentifier']),
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
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  children: [
                    /// Première page : Page d'Accueil
                    SingleChildScrollView(
                      child: SizedBox(
                        height: context.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //caroussel
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                //products images
                                CarouselSlider(
                                    items: _carouselList,
                                    carouselController: controller,
                                    options: CarouselOptions(
                                        autoPlay: true,
                                        autoPlayCurve:
                                            Curves.fastEaseInToSlowEaseOut,
                                        aspectRatio: 11 / 5,
                                        enlargeFactor: 0.5,
                                        viewportFraction: 0.92,
                                        onPageChanged: (index,
                                            CarouselPageChangedReason c) {
                                          //return index;
                                          setState(() {
                                            carouselCurrentIndex = index;
                                          });
                                        })),

                                //dots indicator
                                Positioned(
                                  bottom: 10,
                                  left: context.width * 0.35,
                                  right: context.width * 0.35,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 20,
                                    //width: context.width * 0.25,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background
                                            .withOpacity(0.7),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: PageViewDotIndicator(
                                      currentItem: carouselCurrentIndex,
                                      count: _carouselList.length,
                                      size: const Size(8, 8),
                                      unselectedColor: Colors.grey.shade600,
                                      selectedColor: Colors.grey.shade100,
                                      onItemClicked: (index) {
                                        setState(() {
                                          carouselCurrentIndex = index;
                                          controller.animateToPage(
                                              carouselCurrentIndex);
                                        });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),

                            // barre de recherche
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppTextField(
                                height: context.height * 0.065,
                                color: Theme.of(context).colorScheme.background,
                                prefixIcon: Icons.search,
                                suffixIcon: Icon(
                                  Icons.send,
                                  color: Colors.black26,
                                ),
                                showFloatingLabel: false,
                                label: "Rechercher",
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            //text : Recommandation
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 8.0),
                              child: SizedBox(
                                height: 30,
                                child: AppText(text: 'Recommandations'),
                              ),
                            ),

                            // list recommandation

                            SizedBox(
                              height: context.height * 0.25,
                              child: ListView(
                                padding: const EdgeInsets.all(5),
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                children: _listRecommandations,
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
                          height: context.height * 0.06,
                          width: context.width * 0.9,
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
                          child:
                              TabBarView(controller: _tabcontroller, children: [
                            Center(
                              child: AppText(
                                  text: 'Votre liste de produits est vide'),
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
                  height: context.height * 0.07,
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
            ),
          )
        : LoginPage();
  }
}

/// Recommandations
