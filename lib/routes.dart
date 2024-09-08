import 'package:benin_poulet/views/pages/connexion_pages/loginWithEmailPage.dart';
import 'package:benin_poulet/views/pages/defaultRoutePage.dart';
import 'package:benin_poulet/views/pages/inscription_pages/inscriptionPage.dart';
import 'package:benin_poulet/views/pages/inscription_pages/inscription_vendeurPage.dart';
import 'package:benin_poulet/views/pages/inscription_pages/signupWithEmailPage.dart';
import 'package:benin_poulet/views/pages/started_pages/firstPage.dart';
import 'package:benin_poulet/views/pages/started_pages/presentationPage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/authentification/validationPage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/produits_categories/ajoutNouveauProduitPage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/produits_categories/v_productsCategoriesListPage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/v_commandeListPage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/v_mainPage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/v_presentationBoutiquePage.dart';
import 'package:flutter/cupertino.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/firstPage': (context) => const FirstPage(),
  '/presentationPage': (context) => const PresentationPage(),
  '/inscriptionPage': (context) => const InscriptionPage(),
  '/loginWithEmailPage': (context) => const LoginWithEmailPage(),
  '/signupWithEmailPage': (context) => const SignupWithEmailPage(),
  '/inscriptionVendeurPage': (context) => const InscriptionVendeurPage(),
  '/validationPage': (context) => const ValidationPage(),
  '/vendeurMainPage': (context) => const VMainPage(),
  '/vendeurPresentationBoutiquePage': (context) =>
      const VPresentationBoutiquePage(),
  '/vendeurCommandeListPage': (context) => const VCommandeListPage(),
  '/defaultRoutePage': (context) => const DefaultRoutePage(),
  '/vendeurProduitsListPage': (context) => const VProduitsListPage(),
  '/ajoutNouveauProduitPage': (context) => const AjoutNouveauProduitPage(),
};

class AppRoutes {
  String FIRSTPAGE = '/firstPage';
  String PRESENTATIONPAGE = '/presentationPage';
  String INSCRIPTIONPAGE = '/inscriptionPage';
  String LOGINWITHEMAILPAGE = '/loginWithEmailPage';
  String SIGNUPWITHEMAILPAGE = '/signupWithEmailPage';
  String INSCRIPTIONVENDEURPAGE = '/inscriptionVendeurPage';
  String VALIDATIONPAGE = '/validationPage';
  String VENDEURMAINPAGE = '/vendeurMainPage';
  String VENDEURPRESENTATIONBOUTIQUEPAGE = '/vendeurPresentationBoutiquePage';
  String VENDEURCOMMANDELISTPAGE = '/vendeurCommandeListPage';
  String DEFAULTROUTEPAGE = '/defaultRoutePage';
  String VENDEURPRODUITSLISTPAGE = '/vendeurProduitsListPage';
  String AJOUTNOUVEAUPRODUITPAGE = '/ajoutNouveauProduitPage';
}
