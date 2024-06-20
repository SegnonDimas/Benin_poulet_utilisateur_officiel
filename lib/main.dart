import 'package:benin_poulet/views/pages/connexion_pages/loginPage.dart';
import 'package:benin_poulet/views/pages/connexion_pages/loginWithEmailPage.dart';
import 'package:benin_poulet/views/pages/inscription_pages/inscriptionPage.dart';
import 'package:benin_poulet/views/pages/inscription_pages/inscription_vendeurPage.dart';
import 'package:benin_poulet/views/pages/inscription_pages/signupWithEmailPage.dart';
import 'package:benin_poulet/views/pages/started_pages/firstPage.dart';
import 'package:benin_poulet/views/pages/started_pages/presentationPage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/authentification/validationPage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/creation_boutique/v_presentationBoutiquePage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/v_mainPage.dart';
import 'package:benin_poulet/views/themes/dark_mode.dart';
import 'package:benin_poulet/views/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

// pour la reconnaissance de la langue de l'App en fonction de l'amplacement de l'utilisateur
mixin AppLocale {
  static const String title = 'title';
  static const String thisIs = 'thisIs';

  static const Map<String, dynamic> EN = {
    title: 'Localization',
    thisIs: 'This is %a package, version %a.',
  };
  static const Map<String, dynamic> FR = {
    title: 'Localisation',
    thisIs: 'Ceci est un paquet %a, version %a.',
  };
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  void initState() {
    _localization.init(
      mapLocales: [
        const MapLocale(
          'en',
          AppLocale.EN,
          countryCode: 'US',
          //fontFamily: 'Font EN',
        ),
        const MapLocale(
          'fr',
          AppLocale.FR,
          countryCode: 'FR',
          //fontFamily: 'Font FR',
        ),
      ],
      initLanguageCode: 'fr',
    );
    _localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      supportedLocales: _localization.supportedLocales,
      localizationsDelegates: _localization.localizationsDelegates,
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      darkTheme: darkMode,
      //themeMode: ThemeMode.light,
      title: 'Bénin Poulet',

      home: const VMainPage(),
      routes: {
        '/firstPage': (context) => const FirstPage(),
        '/loginPage': (context) => const LoginPage(),
        '/presentationPage': (context) => const PresentationPage(),
        '/inscriptionPage': (context) => const InscriptionPage(),
        '/loginWithEmailPage': (context) => const LoginWithEmailPage(),
        '/signupWithEmailPage': (context) => const SignupWithEmailPage(),
        '/inscriptionVendeurPage': (context) => const InscriptionVendeurPage(),
        '/validationPage': (context) => const ValidationPage(),
        '/vendeurMainPage': (context) => const VMainPage(),
        '/vendeurPresentationBoutiquePage': (context) =>
            const VPresentationBoutiquePage(),
      },
      //
      //initialRoute: '/firstPage',
    );
  }
}
