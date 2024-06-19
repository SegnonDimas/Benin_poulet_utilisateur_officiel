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
  final PageController _pageViewController = PageController(initialPage: 0);

  final List<Icon> bottomNavigationBarItems = [
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

  final List<Widget> _pages = [
    VHomePage(),
    Center(
      child: AppText(text: 'Products page'),
    ),
    Center(
      child: Container(child: AppText(text: 'Commandes page')),
    ),
    Center(
      child: AppText(text: 'Messages page'),
    ),
    Center(
      child: AppText(text: 'Account page'),
    ),
  ];

  final List<Widget> _pagesTitle = [
    AppText(text: 'Accueil'),
    AppText(text: 'Produits'),
    AppText(text: 'Commandes'),
    AppText(text: 'Messages'),
  ];

  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _pagesTitle[current],
        actions: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.notifications_sharp),
          )
        ],
      ),
      body: Center(
        child: PageView(
          controller: _pageViewController,
          onPageChanged: (index) {
            setState(() {
              current = index;
            });
          },
          children: _pages,
        ),
      ),

      /*Center(
        child: Center(child : AppText(
          text: 'Welcom to your home page',
        ),
      ),*/
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor:
            Colors.transparent, //Theme.of(context).colorScheme.background,
        color: Theme.of(context).colorScheme.surface,
        //buttonBackgroundColor: primaryColor,
        //selectedColor: Colors.white,
        //unselectedColor: Theme.of(context).colorScheme.inversePrimary,
        items: bottomNavigationBarItems,

        index: current,
        onTap: (index) {
          //Handle button tap
          setState(() {
            current = index;
            //_pageViewController.jumpToPage(current);
            _pageViewController.animateToPage(current,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut);
          });
        },
      ),
    );
  }
}
