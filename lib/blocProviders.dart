import 'package:benin_poulet/bloc/fiscalty/fiscal_bloc.dart';
import 'package:benin_poulet/bloc/product/product_bloc.dart';
import 'package:benin_poulet/bloc/storeCreation/store_creation_bloc.dart';
import 'package:benin_poulet/bloc/store/store_bloc.dart';
import 'package:benin_poulet/bloc/order/order_bloc.dart' as old_order;
import 'package:benin_poulet/bloc/userRole/user_role_bloc.dart';
import 'package:benin_poulet/bloc/performance/performance_bloc.dart';
import 'package:benin_poulet/bloc/orders/order_bloc.dart' as new_order;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/authentification/authentification_bloc.dart';
import 'bloc/choixCategorie/secteur_bloc.dart';
import 'bloc/delivery/delivery_bloc.dart';
import 'bloc/store_review/store_review_bloc.dart';
import 'bloc/product_review/product_review_bloc.dart';

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

  // gestion des boutiques
  BlocProvider(create: (context) => StoreBloc()),

  // gestion des commandes (ancien système - à migrer)
  BlocProvider(create: (context) => old_order.OrderBloc()),

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
  BlocProvider(create: (context) => ProductBloc()),

  // avis des boutiques
  BlocProvider(create: (context) => StoreReviewBloc()),

  // avis des produits
  BlocProvider(create: (context) => ProductReviewBloc()),

  // performances vendeur
  BlocProvider(create: (context) => PerformanceBloc()),

  // gestion des commandes - nouveau système complet (client & vendeur)
  BlocProvider(create: (context) => new_order.OrderBloc()),

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
