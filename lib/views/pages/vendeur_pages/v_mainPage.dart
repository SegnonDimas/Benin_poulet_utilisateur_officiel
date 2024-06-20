import 'package:benin_poulet/views/pages/vendeur_pages/v_homePage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../../widgets/app_text.dart';
import '../../sizes/text_sizes.dart';

class VMainPage extends StatefulWidget {
  const VMainPage({super.key});

  @override
  State<VMainPage> createState() => _VMainPageState();
}

class _VMainPageState extends State<VMainPage> {
  // page view controller
  final PageController _pageViewController = PageController(
    initialPage: 0,
  );

  // liste des icônes du bottomNavigationBar
  final List<Icon> _bottomNavigationBarItems = [
    Icon(
      Icons.storefront,
      size: largeText() * 1.2,
    ),
    Icon(Icons.edit_calendar_rounded, size: largeText() * 1.2),
    Icon(
      Icons.payment,
      size: largeText() * 1.2,
    ),
    Icon(
      Icons.wechat_rounded,
      size: largeText() * 1.2,
    ),
  ];

  // liste des pages de la page principale
  final List<Widget> _pages = [
    const VHomePage(),
    Center(
      child: AppText(text: 'Products page'),
    ),
    Center(
      child: AppText(text: 'Commandes page'),
    ),
    Center(
      child: AppText(text: 'Messages page'),
    ),
  ];

  // liste des titres de l'AppBar (en fonction de l'index de la page currentPagee
  final List<Widget> _pagesTitle = [
    AppText(text: 'Accueil'),
    AppText(text: 'Produits'),
    AppText(text: 'Commandes'),
    AppText(text: 'Messages'),
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///AppBar
      appBar: AppBar(
        title: _pagesTitle[currentPage],
        actions: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.notifications_sharp),
          )
        ],
      ),

      /// corps de l'app
      body: Center(
        child: PageView.builder(
          itemCount: _pages.length,
          controller: _pageViewController,
          onPageChanged: (index) {
            setState(() {
              if (index == _pages.length) {
                currentPage = _pages.length - 1;
              } else {
                currentPage = index;
              }
            });
          },
          itemBuilder: (BuildContext context, int index) {
            return _pages[currentPage];
          },

          /*controller: _pageViewController,
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });
          },
          children: _pages,*/
        ),
      ),

      /// bottomNavigationBar
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Theme.of(context).colorScheme.surface,
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
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut);
          });
        },
      ),
    );
  }
}
