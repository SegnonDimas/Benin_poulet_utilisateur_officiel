import 'package:benin_poulet/bloc/storeCreation/store_creation_bloc.dart';
import 'package:benin_poulet/tests/secteur_vendeur/bloc/secteur_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/authentification/authentification_bloc.dart';

List<SingleChildWidget> providers = [
  // authentification
  BlocProvider(create: (context) => AuthBloc()),

  // creation boutique
  BlocProvider(create: (context) => StoreCreationBloc()),

  // niveau creation boutique
  //BlocProvider(create: (context) => NiveauCreationBoutiqueBloc()),

  // authentification de compte vendeur
  BlocProvider(create: (context) => AuthentificationBloc()),

  // choix de catégorie
  BlocProvider(create: (context) => SecteurBloc()),

  // secteur
  BlocProvider(create: (context) => SecteurBloc()),
];
