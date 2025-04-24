import 'package:benin_poulet/blocProviders.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/produits_categories/productsList.dart';
import 'package:benin_poulet/views/themes/dark_mode.dart';
import 'package:benin_poulet/views/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

import 'constants/routes.dart';
import 'core/firebase/firebase_initializer.dart';

void main() async {
  // WidgetsFlutterBinding init
  WidgetsFlutterBinding.ensureInitialized();
  // firebase init
  await FirebaseInitialize.initializeFirebase();
  // flutter_localization init
  await FlutterLocalization.instance.ensureInitialized();
  // runApp
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ProductImagesPathIndexProvider(),
      ),
    ],
    child: const MyApp(),
  )

      /*ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),*/
      );
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
    return MultiBlocProvider(
      providers: providers,
      child: GetMaterialApp(
        supportedLocales: _localization.supportedLocales,
        localizationsDelegates: _localization.localizationsDelegates,
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).themeData,
        darkTheme: darkMode,
        //themeMode: ThemeMode.light,
        title: 'Bénin Poulet',

        //home: ChoixCategoriePage(),
        //home: const FirstPage(),

        routes: routes,
        initialRoute: AppRoutes.FIRSTPAGE,
        //home: FiscalityPage(),
      ),
    );
  }
}
