import 'package:benin_poulet/views/pages/client_pages/c_homePage.dart';
import 'package:benin_poulet/views/pages/client_pages/home_client_page.dart';
import 'package:benin_poulet/views/pages/client_pages/store_client_page.dart';
import 'package:benin_poulet/views/pages/client_pages/product_client_page.dart';
import 'package:benin_poulet/views/pages/client_pages/cart_client_page.dart';
import 'package:benin_poulet/views/pages/client_pages/orders_client_page.dart';
import 'package:benin_poulet/views/pages/client_pages/chat_client_page.dart';
import 'package:benin_poulet/views/pages/client_pages/profile_client_page.dart';
import 'package:benin_poulet/views/pages/client_pages/favorites_client_page.dart';
import 'package:benin_poulet/views/pages/client_pages/review_client_page.dart';
import 'package:benin_poulet/views/pages/connexion_pages/loginPage.dart';
import 'package:benin_poulet/views/pages/connexion_pages/loginWithEmailPage.dart';
import 'package:benin_poulet/views/pages/defaultRoutePage.dart';
import 'package:benin_poulet/views/pages/inscription_pages/inscriptionPage.dart';
import 'package:benin_poulet/views/pages/inscription_pages/signupWithEmailPage.dart';
import 'package:benin_poulet/views/pages/started_pages/firstPage.dart';
import 'package:benin_poulet/views/pages/started_pages/presentationPage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/authentification/validationPage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/creation_boutique/creation_boutiquePage.dart';
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

// Import des modèles depuis les BLoCs client
import '../bloc/client/home_client_bloc.dart';

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
  '/creationBoutiquePage': (context) => const CreationBoutiquePage(),

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
  '/clientHomePage': (context) => const CHomePage(),
  '/home': (context) => const HomeClientPage(),
  '/store-details': (context) => StoreClientPage(
        store: ModalRoute.of(context)!.settings.arguments as Store,
      ),
  '/product-details': (context) => ProductClientPage(
        product: ModalRoute.of(context)!.settings.arguments as Product,
      ),
  '/cart': (context) => const CartClientPage(),
  '/orders': (context) => const OrdersClientPage(),
  '/chat': (context) => ChatClientPage(
        store: ModalRoute.of(context)!.settings.arguments as Store,
      ),
  '/profile': (context) => const ProfileClientPage(),
  '/favorites': (context) => const FavoritesClientPage(),
  '/review': (context) => ReviewClientPage(
        item: ModalRoute.of(context)!.settings.arguments as dynamic,
        type: ModalRoute.of(context)!.settings.arguments is Product ? 'product' : 'store',
      ),
  '/checkout': (context) => const DefaultRoutePage(), // TODO: Créer CheckoutClientPage
  '/order-details': (context) => const DefaultRoutePage(), // TODO: Créer OrderDetailsClientPage
  '/change-password': (context) => const DefaultRoutePage(), // TODO: Créer ChangePasswordClientPage
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
  static String CREATIONBOUTIQUEPAGE = '/creationBoutiquePage';

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
  static String CLIENTHOMEPAGE = '/clientHomePage';
  static String HOME = '/home';
  static String STOREDETAILS = '/store-details';
  static String PRODUCTDETAILS = '/product-details';
  static String CART = '/cart';
  static String ORDERS = '/orders';
  static String CHAT = '/chat';
  static String PROFILE = '/profile';
  static String FAVORITES = '/favorites';
  static String REVIEW = '/review';
  static String CHECKOUT = '/checkout';
  static String ORDERDETAILS = '/order-details';
  static String CHANGEPASSWORD = '/change-password';
}

@Deprecated("Utiliser AppRoutes.[ROUTENAME] à la place")
AppRoutes appRoutes = AppRoutes();
