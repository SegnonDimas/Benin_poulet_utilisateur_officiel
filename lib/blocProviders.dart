import 'package:benin_poulet/bloc/storeCreation/store_creation_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import 'bloc/auth/auth_bloc.dart';

List<SingleChildWidget> providers = [
  BlocProvider(create: (context) => AuthBloc()), //
  BlocProvider(create: (context) => StoreCreationBloc()), // authentification
];
