import 'package:benin_poulet/bloc/fiscalty/fiscal_bloc.dart';
import 'package:benin_poulet/bloc/product/product_bloc.dart';
import 'package:benin_poulet/bloc/storeCreation/store_creation_bloc.dart';
import 'package:benin_poulet/bloc/user_profile_bloc.dart';
import 'package:benin_poulet/models/produit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/authentification/authentification_bloc.dart';
import 'bloc/choixCategorie/secteur_bloc.dart';
import 'bloc/delivery/delivery_bloc.dart';

List<SingleChildWidget> providers = [
  // authentification
  BlocProvider(create: (context) => AuthBloc()),

  // profil utilisateur
  BlocProvider(create: (context) => UserProfileBloc()),

  // creation boutique
  BlocProvider(create: (context) => StoreCreationBloc()),

  // niveau creation boutique
  //BlocProvider(create: (context) => NiveauCreationBoutiqueBloc()),

  // authentification de compte vendeur
  BlocProvider(create: (context) => AuthentificationBloc()),

  // choix de secteurs et catégories
  BlocProvider(create: (context) => SecteurBloc()),

  // information fiscaux
  BlocProvider(create: (context) => FiscalBloc()),

  // information de livraison
  BlocProvider(create: (context) => DeliveryBloc()),

  // produits
  BlocProvider(create: (context) => ProductBloc(list_produits)),
];
