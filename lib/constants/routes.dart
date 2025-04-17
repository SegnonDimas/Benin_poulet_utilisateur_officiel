import 'package:benin_poulet/views/pages/client_pages/c_homePage.dart';
import 'package:benin_poulet/views/pages/connexion_pages/loginPage.dart';
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
import 'package:benin_poulet/views/pages/vendeur_pages/v_historiqueTranslations.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/v_mainPage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/v_performancesPage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/v_portefeuillePage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/v_presentationBoutiquePage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/v_profilPage.dart';
import 'package:flutter/cupertino.dart';

import '../views/pages/vendeur_pages/creation_boutique/authentificationPage.dart';

Map<String, Widget Function(BuildContext)> routes = {
  //======================
  // ROUTES VENDEUR/CLIENT
  //======================
  '/firstPage': (context) => const FirstPage(),
  '/loginPage': (context) => const LoginPage(),
  '/presentationPage': (context) => const PresentationPage(),
  '/inscriptionPage': (context) => const InscriptionPage(),
  '/loginWithEmailPage': (context) => const LoginWithEmailPage(),
  '/signupWithEmailPage': (context) => const SignupWithEmailPage(),
  '/inscriptionVendeurPage': (context) => const InscriptionVendeurPage(),

  //======================
  // ROUTES VENDEUR
  //======================
  '/validationPage': (context) => const ValidationPage(),
  '/vendeurMainPage': (context) => const VMainPage(),
  '/vendeurPresentationBoutiquePage': (context) =>
      const VPresentationBoutiquePage(),
  '/vendeurCommandeListPage': (context) => const VCommandeListPage(),
  '/defaultRoutePage': (context) => const DefaultRoutePage(),
  '/vendeurProduitsListPage': (context) => const VProduitsListPage(),
  '/ajoutNouveauProduitPage': (context) => const AjoutNouveauProduitPage(),
  '/vendeurPerformancesPage': (context) => const VPerformancesPage(),
  '/vendeurProfilPage': (context) => const VProfilPage(),
  '/vendeurPortefeuillePage': (context) => const VPortefeuillePage(),
  '/vendeurHistoriqueTranslations': (context) =>
      const VHistoriqueTranslations(),
  '/vendeurAuthentificationPage': (centext) => AuthentificationVendeurPage(),

  //======================
  // ROUTES CLIENT
  //======================
  'clientHomePage': (context) => const CHomePage(),
};

class AppRoutes {
  //======================
  // ROUTES VENDEUR/CLIENT
  //======================
  static String FIRSTPAGE = '/firstPage';
  static String LOGINPAGE = '/loginPage';
  static String PRESENTATIONPAGE = '/presentationPage';
  static String INSCRIPTIONPAGE = '/inscriptionPage';
  static String LOGINWITHEMAILPAGE = '/loginWithEmailPage';
  static String SIGNUPWITHEMAILPAGE = '/signupWithEmailPage';
  static String INSCRIPTIONVENDEURPAGE = '/inscriptionVendeurPage';

  //======================
  // ROUTES VENDEUR
  //======================
  static String VALIDATIONPAGE = '/validationPage';
  static String VENDEURMAINPAGE = '/vendeurMainPage';
  static String VENDEURPRESENTATIONBOUTIQUEPAGE =
      '/vendeurPresentationBoutiquePage';
  static String VENDEURCOMMANDELISTPAGE = '/vendeurCommandeListPage';
  static String DEFAULTROUTEPAGE = '/defaultRoutePage';
  static String VENDEURPRODUITSLISTPAGE = '/vendeurProduitsListPage';
  static String AJOUTNOUVEAUPRODUITPAGE = '/ajoutNouveauProduitPage';
  static String VENDEURPERFORMANCESPAGE = '/vendeurPerformancesPage';
  static String VENDEURPROFILPAGE = '/vendeurProfilPage';
  static String VENDEURPORTEFEUILLEPAGE = '/vendeurPortefeuillePage';
  static String VENDEURHISTORIQUEPAGE = '/vendeurHistoriqueTranslations';
  static String VENDEURAUTHENTIFICATIONPAGE = '/vendeurAuthentificationPage';

  //======================
  // ROUTES CLIENT
  //======================
  static String CLIENTHOMEPAGE = 'clientHomePage';
}

@Deprecated("Utiliser AppRoutes.[ROUTENAME] à la place")
AppRoutes appRoutes = AppRoutes();
