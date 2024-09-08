import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/v_homePage.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
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
      Icons.home_filled,
      size: largeText() * 1.2,
    ),
    /*Icon(Icons.edit_calendar_rounded, size: largeText() * 1.2),
    Icon(
      Icons.payment,
      size: largeText() * 1.2,
    ),*/
    Icon(
      Icons.wechat_rounded,
      size: largeText() * 1.2,
    ),
  ];

  // liste des pages de la page principale
  final List<Widget> _pages = [
    const VHomePage(),
    Center(
      child: AppText(text: 'Messages page'),
    ),
  ];

  // liste des titres de l'AppBar (en fonction de l'index de la page currentPagee
  final List<Widget> _pagesTitle = [
    AppText(text: 'Accueil'),
    AppText(text: 'Messages'),
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    var space = SizedBox(
      height: appHeightSize(context) * 0.05,
    );
    return Scaffold(
      ///Drawer
      drawer: Drawer(
        child: Column(
          children: [
            space,
            // logo de benin poulet
            Image.asset(
              'assets/logos/logoNoir.png',
              width: appWidthSize(context) * 0.2,
            ),

            // espace
            space,
            space,
            space,

            // option : partager
            SizedBox(
              width: appWidthSize(context) * 0.7,
              child: ListTile(
                leading: Icon(
                  Icons.share,
                  color: primaryColor,
                ),
                title: AppText(
                  text: 'Partager',
                ),
                trailing: Icon(Icons.touch_app),
              ),
            ),

            // option : infos sur nous
            SizedBox(
              width: appWidthSize(context) * 0.7,
              child: ListTile(
                leading: Icon(
                  Icons.info,
                  color: primaryColor,
                ),
                title: AppText(
                  text: 'Infos sur nous',
                ),
                trailing: Icon(Icons.touch_app),
              ),
            ),

            // option : guide d'utilisation
            SizedBox(
              width: appWidthSize(context) * 0.7,
              child: ListTile(
                leading: Icon(
                  Icons.document_scanner,
                  color: primaryColor,
                ),
                title: AppText(
                  text: 'Guide d\'utilisation',
                ),
                trailing: Icon(Icons.touch_app),
              ),
            ),

            // option : paramètres
            SizedBox(
              width: appWidthSize(context) * 0.7,
              child: ListTile(
                leading: Icon(
                  Icons.settings,
                  color: primaryColor,
                ),
                title: AppText(
                  text: 'Paramètres',
                ),
                trailing: Icon(Icons.touch_app),
              ),
            )
          ],
        ),
      ),

      ///AppBar
      appBar: AppBar(
        //leading: IconButton(onPressed: null, icon: Icon(Icons.account_circle)),
        title: _pagesTitle[currentPage],
        centerTitle: true,
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
                curve: Curves.linear);
          });
        },
      ),
    );
  }
}
