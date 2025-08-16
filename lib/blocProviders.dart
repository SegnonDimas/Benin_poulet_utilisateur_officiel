import 'package:benin_poulet/bloc/fiscalty/fiscal_bloc.dart';
import 'package:benin_poulet/bloc/product/product_bloc.dart';
import 'package:benin_poulet/bloc/storeCreation/store_creation_bloc.dart';
import 'package:benin_poulet/bloc/userRole/user_role_bloc.dart';
import 'package:benin_poulet/models/produit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/authentification/authentification_bloc.dart';
import 'bloc/choixCategorie/secteur_bloc.dart';
import 'bloc/delivery/delivery_bloc.dart';

// BLoCs client
import 'bloc/client/home_client_bloc.dart';
import 'bloc/client/store_client_bloc.dart';
import 'bloc/client/product_client_bloc.dart';
import 'bloc/client/cart_client_bloc.dart';
import 'bloc/client/orders_client_bloc.dart';
import 'bloc/client/chat_client_bloc.dart';
import 'bloc/client/profile_client_bloc.dart';
import 'bloc/client/favorites_client_bloc.dart';
import 'bloc/client/review_client_bloc.dart';

List<SingleChildWidget> providers = [
  // authentification
  BlocProvider(create: (context) => AuthBloc()),

  // profil utilisateur
  BlocProvider(create: (context) => UserRoleBloc()),

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

  // BLoCs client
  BlocProvider(create: (context) => HomeClientBloc()),
  BlocProvider(create: (context) => StoreClientBloc()),
  BlocProvider(create: (context) => ProductClientBloc()),
  BlocProvider(create: (context) => CartClientBloc()),
  BlocProvider(create: (context) => OrdersClientBloc()),
  BlocProvider(create: (context) => ChatClientBloc()),
  BlocProvider(create: (context) => ProfileClientBloc()),
  BlocProvider(create: (context) => FavoritesClientBloc()),
  BlocProvider(create: (context) => ReviewClientBloc()),
];
