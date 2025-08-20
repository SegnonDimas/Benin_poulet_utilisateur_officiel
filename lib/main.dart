import 'dart:async';

import 'package:benin_poulet/blocProviders.dart';
import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/constants/userRoles.dart';
import 'package:benin_poulet/core/firebase/auth/auth_services.dart';
import 'package:benin_poulet/services/cache_manager.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/produits_categories/productsList.dart';
import 'package:benin_poulet/views/themes/dark_mode.dart';
import 'package:benin_poulet/views/themes/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Firebase
  await Firebase.initializeApp();

  // Initialiser GetStorage
  await GetStorage.init();

  // Initialiser le cache manager
  await CacheManager.init();
  

  
  // créer une connexion anonyme au lancement
  final anonymousUser = await AuthServices.createAnonymousAuth();
  anonymousUser;

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
  ));
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final instance = GetStorage();

  @override
  void initState() {
    // juste pour tests TODO : à enlever
    GetStorage().write('se_souvenir', false);

    //
    instance.write('se_souvenir', instance.read('se_souvenir') ?? false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: GetMaterialApp(
        supportedLocales: const [
          Locale('fr', 'FR'),
          Locale('en', 'US'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).themeData,
        darkTheme: darkMode,
        //themeMode: ThemeMode.light,
        title: 'Bénin Poulet',

        routes: routes,
        initialRoute: AppRoutes.FIRSTPAGE,

        builder: EasyLoading.init(),
        //home: HomeClientPage(),
        //home: ListProduitFirebase(),
      ),
    );
  }
}
